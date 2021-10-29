use async_std::channel;
use async_std::task;
use futures::{
    future::FutureExt, // for `.fuse()`
    pin_mut,
    select,
};
use std::sync::Mutex;
use std::thread;
use std::time::Duration;

#[macro_use]
extern crate lazy_static;

#[repr(C)]
pub enum AwesomexExitCode {
    Ok = 0,
    Error = 1,
    Already = 2,
}

lazy_static! {
    static ref WORK_DONE: (channel::Sender<()>, channel::Receiver<()>) = channel::unbounded();
    static ref WORK_THREAD_MU: Mutex<Option<thread::JoinHandle<()>>> = Default::default();
}

async fn say_hi() {
    println!("awesomex: working...");
    task::sleep(Duration::from_secs(30)).await;
    println!("awesomex: done!");
}

async fn work_main_async() {
    let hello_future = say_hi().fuse();
    let done_future = WORK_DONE.1.recv().fuse();

    pin_mut!(hello_future, done_future);

    select! {
        () = hello_future => eprintln!("awesomex: future is done"),
        _ = done_future => eprintln!("awesomex: killed by the done channel"),
    };
}

fn work_main() {
    task::block_on(work_main_async())
}

#[no_mangle]
pub extern "C" fn awesomex_start() -> AwesomexExitCode {
    let mut guard = match WORK_THREAD_MU.lock() {
        Ok(guard) => guard,
        Err(poisoned) => poisoned.into_inner(),
    };

    if guard.is_some() {
        eprintln!("awesomex: the work thread is already started");
        return AwesomexExitCode::Already;
    }

    let handler = thread::spawn(work_main);
    guard.replace(handler);

    AwesomexExitCode::Ok
}

#[no_mangle]
pub extern "C" fn awesomex_stop() -> AwesomexExitCode {
    let mut guard = match WORK_THREAD_MU.lock() {
        Ok(guard) => guard,
        Err(poisoned) => poisoned.into_inner(),
    };

    if guard.is_none() {
        eprintln!("awesomex: the work thread is already stopped");
        return AwesomexExitCode::Already;
    }

    let thread = match guard.take() {
        Some(t) => t,
        None => return AwesomexExitCode::Error,
    };

    let exit_code = match task::block_on(WORK_DONE.0.send(())) {
        Ok(_) => AwesomexExitCode::Ok,
        Err(err) => {
            eprintln!("awesomex: failed to close the done channel: {}", err);
            AwesomexExitCode::Error
        }
    };

    match thread.join() {
        Ok(_) => exit_code,
        Err(err) => {
            eprintln!("awesomex: failed to join the work thread: {:?}", err);
            AwesomexExitCode::Error
        }
    }
}
