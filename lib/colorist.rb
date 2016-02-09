require 'colorist/version'

class Color < Struct.new(:name,:red,:green,:blue); end

Red   = Color.new(:red,   256,   0,   0)
Green = Color.new(:green,   0, 256,   0)
Blue  = Color.new(:blue,    0,   0, 256)

Orange = Color.new(:orange, 256, 165, 0)
Yellow = Color.new(:yellow, 256, 256, 0)

White = Color.new(:white, 256, 256, 256)
Purple = Color.new(:purple, 128, 0, 128)
Lavender = Color.new(:lavender, 192, 128, 192)

Black = Color.new(:black, 0, 0, 0)

SimplePalette = [ Red, Green, Blue, Orange, Yellow, White, Black ]

Peach = Color.new(:peach, 256, 218, 185)
Sienna = Color.new(:sienna, 160,82,45)

class Mixture
  attr_reader :sources

  def initialize((a,b))
    @sources = [a,b]
  end

  def color
    color_result = Color.new(
      sources.map(&:name).join('-'),
      average(sources.map(&:red)),
      average(sources.map(&:green)),
      average(sources.map(&:blue))
    )
    color_result
  end

  MAX_DEPTH = 4
  ALLOWANCE = 5
  def self.infer(target_color, palette=SimplePalette, depth=0)
    raise "Could not mix #{target_color} (mix depth exceeded)" if depth > MAX_DEPTH

    # p [ :infer, target: target_color, palette: palette, depth: depth ]

    first_to_mix,second_to_mix = palette.combination(2).detect do |combo| #(a,b)|
      print '.'
      mixture = Mixture.new(combo) #[a,b])

      d_red, d_blue, d_green = 
        (mixture.color.red - target_color.red).abs, 
        (mixture.color.blue - target_color.blue).abs, 
        (mixture.color.green - target_color.green).abs

      d_red < ALLOWANCE && d_blue < ALLOWANCE && d_green < ALLOWANCE
    end

    #aise "Couldn't mix #{target_color}"
    if first_to_mix.nil? || second_to_mix.nil?
      palette += palette.combination(2).map do |combo|
        Mixture.new(combo).color
      end

      infer(target_color, palette, depth+1)
    else
      Mixture.new([first_to_mix, second_to_mix])
    end
  end

  protected
  def average(as)
    (as.inject(&:+) / as.size)
  end
end
