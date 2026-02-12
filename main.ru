from telegram import Update
from telegram.ext import Application, CommandHandler, MessageHandler, filters, ContextTypes
from gigachat import GigaChat


# Инициализация GigaChat
gc = GigaChat(
    credentials=config("GIGACHAT_API_KEY"),
    verify_ssl_certs=False
)

async def start(update: Update, context: ContextTypes.DEFAULT_TYPE):
    await update.message.reply_text("Привет! Напиши мне что‑нибудь — я отвечу через нейросеть.")


async def echo(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user_text = update.message.text

    # Проверяем, что это не команда и текст достаточно длинный
    if len(user_text.strip()) < 50:
        await update.message.reply_text("Введите текст длиннее 50 символов для суммаризации.")
        return

    try:
        # Промт для нейросети: сделать тезисный пересказ
        prompt = f"""
        Сделай краткий тезисный пересказ следующего текста. Выдели 3–5 ключевых мыслей. 
        Каждый тезис напиши с новой строки, начиная с цифры и точки.


        Текст:
        {user_text}
        """

        response = gc.chat(prompt)
        summary = response.choices[0].message.content

        await update.message.reply_text(f"Краткий пересказ:\n\n{summary}")


    except Exception as e:
        await update.message.reply_text(f"Ошибка при суммаризации: {e}")

def main():
    TELEGRAM_TOKEN = "TELEGRAMM TOKEN"
    app = Application.builder().token(config("TELEGRAM_TOKEN")).build()
    application.add_handler(CommandHandler("start", start))
    application.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, echo))
    print("Бот запущен. Ожидание сообщений...")
    application.run_polling()

if __name__ == "__main__":
    main()


