
class Onoff

  def initialize(ev3_car)
    @ev3_car = ev3_car
    @font = Font.new(60)
  end

  def update
    @color = @ev3_car.get_color
  end

  def switch
    if @color != (0 or 6 or 7)
      Window.draw_font(110, 510, "on road",@font)
    else
      Window.draw_font(110, 510, "off road",@font)
    end
  end

end


