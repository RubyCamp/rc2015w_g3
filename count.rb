
class Count

  def initialize(ev3_car)
    @ev3_car = ev3_car
    @font = Font.new(50)
    @count = 0
  end

  def update
    @color = @ev3_car.get_color
  end


  def switch
    if @color == 5
      @count += 1
    end
    Window.draw_font(750,515,"#{@count}",@font)

  end

end

