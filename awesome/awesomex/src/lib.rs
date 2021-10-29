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
pub extern "C" fn awesomex_start() -> i32 {
    let mut guard = match WORK_THREAD_MU.lock() {
        Ok(guard) => guard,
        Err(poisoned) => poisoned.into_inner(),
    };

    if guard.is_some() {
        eprintln!("awesomex: the work thread is already started");
        return 2;
    }

    let handler = thread::spawn(work_main);
    guard.replace(handler);

    0
}

#[no_mangle]
pub extern "C" fn awesomex_stop() -> i32 {
    let mut guard = match WORK_THREAD_MU.lock() {
        Ok(guard) => guard,
        Err(poisoned) => poisoned.into_inner(),
    };

    if guard.is_none() {
        eprintln!("awesomex: the work thread is already stopped");
        return 1;
    }

    let thread = match guard.take() {
        Some(t) => t,
        None => return 2,
    };

    let exit_code = match task::block_on(WORK_DONE.0.send(())) {
        Ok(_) => 0,
        Err(err) => {
            eprintln!("awesomex: failed to close the done channel: {}", err);
            1
        }
    };

    match thread.join() {
        Ok(_) => exit_code,
        Err(err) => {
            eprintln!("awesomex: failed to join the work thread: {:?}", err);
            1
        }
    }
}
