
class Distance

  def initialize(ev3_car)
    @ev3_car = ev3_car
    @font = Font.new(50)
  end

  def update
    @distance = @ev3_car.get_distance
  end

  def tance
    Window.draw_font(750, 60,"#{@distance.to_i}cm",@font)
  end

end


