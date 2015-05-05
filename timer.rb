
class Timer
  def initialize
    @font = Font.new(45)
    @time1=Time.now
    @time2=@time1
  end

  def countup
  #if Input.keyPush?(K_RETURN)
    @time2=Time.now
  #end

  @total_sec = @time2.to_i - @time1.to_i
  @sec = @total_sec % 60
  @total_min = @total_sec.to_i/60
  @min = @total_min % 60

  Window.draw_font(250,65,(@min.to_s + "分" + @sec.to_s + "秒"),@font)
  #if time2
    #Window.draw_font(250,65,(@time2-@time1).to_i.to_s+" 秒",@font)
  #end
  end

end

