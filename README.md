# WhatsStory

WhatsStory is an automation tool built with shell scripts designed to regularly back up WhatsApp status (stories), organize them into daily archives, and send summary notifications via Telegram.

## Features

* Save the latest WhatsApp statuses to a daily folder.
* Move older statuses into date-based archive folders.
* Generate daily activity logs.
* Send Telegram notifications with a daily summary.
* Auto-loop mode using cron jobs or custom service scripts.

## Project Structure

```
.
├── main.sh                  # Main script to start all processes
├── setup.sh                 # Initial setup and environment configuration
├── .env.example             # Example environment configuration
├── src/
│   ├── story-daily-saver.sh     # Script to save new statuses
│   └── story-daily-report.sh    # Script to send daily reports to Telegram
├── services/
│   ├── start_notif_loop.sh      # Notification loop
│   ├── start_story_loop_rev.sh  # Story-saving loop
│   └── killself.sh              # Stops the automation
├── logs/                   # Daily log directory
└── .gitignore
```

## Usage

1. Clone this repository.
2. Duplicate `.env.example` to `.env` and fill in the required variables (e.g., WhatsApp status paths, Telegram token).
3. Run `setup.sh` for initial setup.
4. Run `main.sh` to start the automation.

```bash
chmod +x setup.sh main.sh
./setup.sh
./main.sh
```

## Environment Variables (`.env`)

Instead of a single path, WhatsStory supports multiple status directories. You can define them as a comma-separated list:

```bash
STATUS_DIRS="/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses"
OUTPUT_DIR="/sdcard/Download/DailyStoryWa"
TELEGRAM_TOKEN="123456:ABCDEF..."
TELEGRAM_CHAT_ID="123456789"
```

> Internally, `story-daily-saver.sh` reads `STATUS_DIRS` and splits it into an array.

## Notes

* Optimized for Android devices using Termux.
* Use `cronie` to run scripts periodically (e.g., every minute).
* Copied status files are organized into archives by date.

## Contact

If you have questions, ideas, or just want to say hi, feel free to reach out:

* WhatsApp: [+6285157711053](https://wa.me/6285157711053)
* Telegram: [@coinnotion](https://t.me/coinnotion)

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/ibnusyawall/whatsstory/blob/main/LICENSE) file for details.

---

> Built with a passion for tinkering and a warm cup of coffee ☕

