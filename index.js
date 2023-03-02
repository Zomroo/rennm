const { Telegraf } = require('telegraf');

const bot = new Telegraf(process.env.BOT_TOKEN);

bot.start((ctx) => {
  ctx.reply('Welcome! Send me a file and I will help you rename it.');
});

bot.on('document', (ctx) => {
  const { file_name } = ctx.message.document;
  ctx.reply(`The file name is: ${file_name}. What would you like to rename it to?`);
});

bot.hears(/^(?!\/).*$/, (ctx) => {
  const new_name = ctx.message.text;
  ctx.reply(`The file has been renamed to ${new_name}!`);
});

bot.launch();
