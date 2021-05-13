# Checklist

This is a checklist with task to do after system installaction.

I think many of them should be replaced with a script.

## TODO

- [ ] Copy or generate a SSH key. `ssh-keygen -t rsa -b 4096`.

  - [ ] Add this key into your Github profile. `cat ~/.ssh/id_rsa.pub | pbcopy`.

- [ ] Update remote hosts in cloned repos (on the installation).

  - [ ] Dotfiles: `(cd ~/Projects/github.com/SuperPaintman/dotfiles && git remote set-url origin git@github.com:SuperPaintman/dotfiles.git)`.

- [ ] Clone secret dotfiles. `make secrets`.

- [ ] Create token for **telethon** (using in `telegramstatus`).

  1. Login on <https://my.telegram.org/apps>.
  2. Create the config file and paste yout `api_id` and `api_hash`.

  ```sh
  $ mkdir -p ~/.telethon
  $ read -s API_ID
  $ read -s API_HASH
  $ cat << EOF > ~/.telethon/session.json
  {
    "api_id": $API_ID,
    "api_hash": "$API_HASH"
  }
  EOF
  ```

  3. Run `telegramstatus` and follow the instructions.

- [ ] Download the wallpaper. `curl -sL http://localhost -o ~/.wallpaper`.

- [ ] Setup Firefox.

  - [ ] Set the default search engine. `firefox about:preferences#search`.
  - [ ] Set "Open links in tabs instead of new windows".

- [ ] Setup Telegram.

  - [ ] Set the theme.
    1. Download the theme.
    ```sh
    $ curl -sL 'https://github.com/SuperPaintman/Tomorrow-Night-Telegram-Theme/releases/download/v0.1.1/tomorrow-night.tdesktop-theme' -o ~/Downloads/tomorrow-night.tdesktop-theme
    ```
    2. Upload the theme to any chat.
    3. Click on a new message.
    4. `"APPLY THIS THEME"`.
    5. `"KEEP CHANGES"`.
  - [ ] Disable tray icon. `"Settings > Advinced > Show tray icon"`.
  - [ ] Use system window frame. `"Settings > Advinced > Use system window frame"`.
  - [ ] Use native notifications. `"Settings > Notifications > Use native notifications"`.
  - [ ] Disable notification sound. `"Settings > Notifications > Play sound"`.

- [ ] Install Rust toolchain.

  ```sh
  $ rustup default stable
  $ rustup toolchain install stable nightly
  $ rustup +stable component add rust-analysis rls rust-src
  $ rustup +nightly component add rust-analysis rls rust-src
  ```

- [ ] Configure Cargo.

  1. Create a new API token on <https://crates.io/me>.
  2. Create the credentials file using **cargo**.

  ```sh
  $ CRATES_API_TOKEN=<token>
  $ cargo login "$CRATES_API_TOKEN"
  ```

- [ ] Configure AWS Cli.

  1. Create a new access key for my user in <https://console.aws.amazon.com/iam/home>.
  2. Create the config file using **aws**.

  ```sh
  $ aws configure
  ```

- [ ] Copy OpenVPN client config.

  1. Download the config file.
  2. Create `~/.openvpn` dir and copy the downloaded file.

  ```sh
  $ mkdir ~/.openvpn
  $ cp "$OPENVPN_CONFIG_FILE" ~/.openvpn/
  ```

  3. Run `make nixos-switch`.
