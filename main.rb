require 'dxruby'
require_relative '../ruby-ev3/lib/ev3'
require_relative 'timer'
require_relative 'color'
require_relative 'onoff'
require_relative 'distance'
require_relative 'count'

Window.resize(900,600)



class Ev3Car
  LEFT_MOTOR = "C"
  RIGHT_MOTOR = "B"
  ARM_MOTOR = "D"
  COLOR_SENSOR = "1"
  DISTANCE_SENSOR = "2"
  PORT = "COM3"
  MOTOR_SPEED =50
  WHEEL_SPEED = 50
  ARM_SPEED = 10
  TURN_SPEED = 100
  RIGHT_DGREE = 10
  LEFT_DEGREE = 10
  attr_reader :distance#インスタンス変数の値を見れるようにする定義
  attr_reader :brick, :color

  def initialize
    @brick = EV3::Brick.new(EV3::Connections::Bluetooth.new(PORT))
    @brick.connect
    @busy = false
    # puts "starting..."
    # puts "connected..."
  end

  def on_road?
    6 != @brick.get_sensor(COLOR_SENSOR, 2)# what is it?//
  end

  def get_color
    @brick.get_sensor(COLOR_SENSOR,2)
  end

  def get_distance
    @distance = @brick.get_sensor(DISTANCE_SENSOR, 0)
  end

  def run_forward
    @brick.run_forward(*wheel_motors)
    @brick.reverse_polarity(*wheel_motors)
    p wheel_motors
    @brick.start(MOTOR_SPEED, *wheel_motors)
    sleep 0.3
    @brick.stop(true,*wheel_motors)#第一引数で止め方指定、止めるモーター指定
  end

  def run_backward
    @brick.run_forward(*wheel_motors)
    @brick.start(MOTOR_SPEED, *wheel_motors)#
    sleep 0.15#0.2間だけ動かす
    @brick.stop(true, *wheel_motors)#第一引数で止め方指定、止めるモーター指定
  end

  def turn_right

    @brick.run_forward(*wheel_motors)
    @brick.reverse_polarity(*wheel_motors)
    @brick.reverse_polarity(LEFT_MOTOR)#左に頭を振る
    @brick.start(MOTOR_SPEED, *wheel_motors)
    sleep 0.3
    @brick.stop(false, *wheel_motors)
  end

  def turn_left

    @brick.run_forward(*wheel_motors)
    @brick.reverse_polarity(*wheel_motors)
    @brick.reverse_polarity(RIGHT_MOTOR)#左に頭を振る
    @brick.start(MOTOR_SPEED, *wheel_motors)
    sleep 0.3
    @brick.stop(false, *wheel_motors)
  end

  def turn_left2

    @brick.run_forward(*wheel_motors)
    @brick.reverse_polarity(*wheel_motors)
    @brick.reverse_polarity(RIGHT_MOTOR)#左に頭を振る
    @brick.start(MOTOR_SPEED, *wheel_motors)
    sleep 0.3
    @brick.stop(false, *wheel_motors)
  end

  def push_run_forward(speed=WHEEL_SPEED)
    push_operate do
      @brick.reverse_polarity(*wheel_motors)
      @brick.start(speed, *wheel_motors)
    end
  end

  def push_run_backward(speed=WHEEL_SPEED)
    push_operate do
      @brick.start(speed, *wheel_motors)
    end
  end

  def push_turn_right(speed=WHEEL_SPEED)
    push_operate do
      @brick.reverse_polarity(RIGHT_MOTOR)
      @brick.start(speed, *wheel_motors)
    end
  end

  def push_turn_left(speed=WHEEL_SPEED)
    push_operate do
      @brick.reverse_polarity(LEFT_MOTOR)
      @brick.start(speed, *wheel_motors)
    end
  end

  def push_raise_arm(speed=ARM_SPEED)
    push_operate do
      @brick.reverse_polarity(ARM_MOTOR)
      @brick.start(speed, ARM_MOTOR)
    end
  end

  def push_down_arm(speed=ARM_SPEED)
    push_operate do
      @brick.start(speed, ARM_MOTOR)
    end
  end

  def push_stop
    @brick.stop(true, *all_motors)
    @brick.run_forward(*all_motors)
    @busy = false
  end

  def push_operate
    unless @busy
      @busy = true
      yield(@brick)
    end
  end

  def push_run
    update
    push_run_forward if Input.keyDown?(K_UP)
    push_run_backward if Input.keyDown?(K_DOWN)
    push_turn_left if Input.keyDown?(K_LEFT)
    push_turn_right if Input.keyDown?(K_RIGHT)
    push_raise_arm if Input.keyDown?(K_W)
    push_down_arm if Input.keyDown?(K_S)
    push_grab if Input.keyDown?(K_A)
    release if Input.keyDown?(K_D)
    stop if [K_UP, K_DOWN, K_LEFT, K_RIGHT, K_W, K_S].all?{|key| !Input.keyDown?(key) }
  end

  def all_motors
    @all_motors ||= self.class.constants.grep(/_MOTOR\z/).map{|c| self.class.const_get(c) }
  end

  def wheel_motors
    [LEFT_MOTOR, RIGHT_MOTOR]
  end

  def reset
    @brick.reset(*wheel_motors())#
  end

  def close
    @brick.stop(false, *wheel_motors())
    @brick.clear_all
    @brick.disconnect
  end
end

image = Image.load("image/background.png")
time = Timer.new

begin
  ev3Car = Ev3Car.new
  color = Color.new(ev3Car)
  onoff = Onoff.new(ev3Car)
  distance = Distance.new(ev3Car)
  count = Count.new(ev3Car)
  puts "starting..."
  font = Font.new(32)
  puts "connected..."
  ev3Car.reset()
  ev3Car.get_distance
  #@brick.reset(*wheel_motors())#タイヤの回転数に応じての度数をリセット

  Window.loop do
    break if Input.keyDown?( K_SPACE )#スペース押したらプログラム終了
    Window.draw_font(100, 300, "color: #{ev3Car.get_color().to_i}", font)
    Window.draw_font(100, 350, "distance: #{ev3Car.get_distance().to_i}cm", font)#to_iで整数にする
    Window.draw(0,0,image)
    time.countup

    color.update
    color.colorling

    onoff.update
    onoff.switch

    distance.update
    distance.tance

    count.update
    count.switch
    #to_iで整数にする
#ifを延々繰り返す
    #if ev3Car.get_color() == 1
    if ev3Car.get_color() == 1 || ev3Car.get_color() == 5 ||ev3Car.get_color() == 4
      #Window.draw_font(100, 200, "on road",font)
      ev3Car.run_forward
      p"move_forward"
    else#=====================ココカラ
      #Window.draw_font(100, 200, "off road", font)
      # ev3Car.run_backward#戻りが弱い
      #それたところまで戻る============
      #ev3Car.turn_left(ev3Car.wheel_motors())
      p "backward+left"
    #左に首ふる======
      until ev3Car.get_color() == 1 || ev3Car.get_color() == 5 || ev3Car.get_color() == 4
           ev3Car.run_backward#戻りが弱い
           break if ev3Car.get_color() == 1 || ev3Car.get_color() == 5 || ev3Car.get_color() == 4
            ev3Car.turn_left
            break if ev3Car.get_color() == 1 || ev3Car.get_color() == 5 || ev3Car.get_color() == 4
            ev3Car.turn_right
            # break if ev3Car.get_color() == 1 || ev3Car.get_color() == 5
             ev3Car.turn_right
             break if ev3Car.get_color() == 1 || ev3Car.get_color() == 5 || ev3Car.get_color() == 4
             ev3Car.turn_left2
             # break if ev3Car.get_color() == 1 || ev3Car.get_color() == 5
             break if Input.keyDown?( K_SPACE )#
      end
      # if ev3Car.get_color() != 1 || ev3Car.get_color() != 5
      #    ev3Car.turn_left
      #    ev3Car.turn_left
      #    #ev3Car.turn_left#呼び出しは2回まで
      #    # ev3Car.turn_left
      #    #ev3Car.turn_left(ev3Car.wheel_motors())
      #    #ev3Car.turn_left(ev3Car.wheel_motors())
      #    #ev3Car.turn_left(ev3Car.wheel_motors())
      #    ev3Car.turn_right
      #    ev3Car.turn_right
      #    #ev3Car.turn_right
      #    # ev3Car.turn_left2
      #    #ev3Car.turn_right(ev3Car.wheel_motors())
      #    #ev3Car.turn_right(ev3Car.wheel_motors()  )
      #    p "right2+left1"
      #end
    end
  end
#rescue
#  p $!
ensure#　終了時に絶対にやる処理
  puts "closing..."
  #@brick.stop(false, *wheel_motors())
  ev3Car.close
  puts "finished..."
end

#2回以上右振ったら、左に大きく振る