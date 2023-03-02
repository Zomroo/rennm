const TelegramBot = require('node-telegram-bot-api');
const fs = require('fs');
const token = '6145559264:AAEkUH_znhpaTdkbnndwP1Vy2ppv-C9Zf4o';

const bot = new TelegramBot(token, { polling: true });

bot.onText(/\/rename (.+) (.+)/, (msg, match) => {
  const chatId = msg.chat.id;
  const oldFileName = match[1];
  const newFileName = match[2];
  fs.rename(oldFileName, newFileName, function (err) {
    if (err) {
      bot.sendMessage(chatId, `Error: ${err.message}`);
    } else {
      bot.sendMessage(chatId, `File ${oldFileName} renamed to ${newFileName} successfully!`);
    }
  });
});

bot.on('message', (msg) => {
  const chatId = msg.chat.id;
  bot.sendMessage(chatId, 'To rename a file, use the command /rename old_filename new_filename');
});
