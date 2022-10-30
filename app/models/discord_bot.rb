class DiscordBot
  def initialize
    @bot = Discordrb::Commands::CommandBot.new token: ENV['DISCORD_BOT_TOKEN'],
                                               prefix: 'stup!'
  end

  def start
    @bot.command :s, description: '学習時間の記録を開始します。' do |event|
      user = User.find_by(uid: event.user.id)
      if user.nil?
        event.respond "ユーザーが登録されていません。"
      else
        @records = StudyTimeRecord.where(user_id: user.id)
        @start_time = Time.now.strftime("%Y-%m-%d %H:%M")
        if @records.empty?
          user.study_time_records.create(start_at: @start_time)
          event.respond "学習を開始しました。#{@start_time}"
        else
          if @records.last.end_at.nil?
            event.respond "前回の学習が終了していません。"
          else
            user.study_time_records.create(start_at: @start_time)
            event.respond "学習を開始しました。#{@start_time}"
          end
        end
      end
    end

    @bot.command :e, description: '学習時間の記録を終了します。' do |event|
      user = User.find_by(uid: event.user.id)
      if user.nil?
        event.respond "ユーザーが登録されていません。"
      else
        @records = StudyTimeRecord.where(user_id: user.id)
        @end_time = Time.now.strftime("%Y-%m-%d %H:%M")
        if @records.last.end_at.nil?
          user.study_time_records.last.update(end_at: @end_time)
          event.respond "学習を終了しました。#{@end_time}"
        else
          event.respond '学習が開始されていません。'
        end
      end
    end
    @bot.run
  end

  private

  # 最新の学習記録を取得する
  def get_current_study_records

  end

end
