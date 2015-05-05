require 'dxruby'
class Color

  def initialize(ev3_car)
    @ev3_car = ev3_car
    @font = Font.new(35)
    @image0 = Image.load("image/color0.png")
    @image1 = Image.load("image/color1.png")
    @image2 = Image.load("image/color2.png")
    @image3 = Image.load("image/color3.png")
    @image4 = Image.load("image/color4.png")
    @image5 = Image.load("image/color5.png")
    @image6 = Image.load("image/color6.png")
    @image7 = Image.load("image/color7.png")
  end

  def update
    @color = @ev3_car.get_color
  end

  def colorling
    case @color
    when 0
      Window.draw(166, 197,@image0)
    when 1
      Window.draw(166, 197,@image1)
    when 2
      Window.draw(166, 197,@image2)
    when 3
      Window.draw(166, 197,@image3)
    when 4
      Window.draw(166, 197,@image4)
    when 5
      Window.draw(166, 197,@image5)
    when 6
      Window.draw(166, 197,@image6)
    when 7
      Window.draw(166, 197,@image7)
    end
  end

end
