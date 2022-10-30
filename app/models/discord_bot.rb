class DiscordBot
  def initialize
    @bot = Discordrb::Commands::CommandBot.new token: ENV['DISCORD_BOT_TOKEN'],
                                               prefix: 'stup!'
  end

  def start
    @bot.command :s, description: '学習時間の記録を開始します。' do |event|
      event.respond '学習時間の記録を開始しました。'
    end

    @bot.command :e, description: '学習時間の記録を終了します。' do |event|
      event.respond '学習時間の記録を終了しました。'
    end
    @bot.run
  end

end
