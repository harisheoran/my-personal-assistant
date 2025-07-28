from apscheduler.schedulers.background import BackgroundScheduler
import time
from gtts import gTTS
import os
import platform

if platform.system() == "Darwin":
    import os
    def notify(message):
        title = "my-personal-assistant"
        os.system(f'''osascript -e 'display notification "{message}" with title "{title}"' ''')
        notify_audio(message=message)
else:
    from plyer import notification
    def notify(message):
        notification.notify(
            title="my personal assistant",
            message= message,
            app_name="Personal Assistant",
            timeout=10 
        )
        notify_audio(message=message)

def notify_audio(message):
    tts = gTTS(message, lang="en", tld="co.uk")
    tts.save("voice.mp3")
    os.system("mpg123 voice.mp3")

def drink_water_reminder():
    print("starting the drink water reminder")
    notify("Drink water now")

schedular = BackgroundScheduler()
schedular.add_job(drink_water_reminder, 'interval', minutes=90)
schedular.start()

while True:
    time.sleep(1)