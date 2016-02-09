require 'pry'
require 'spec_helper'
require 'colorist'

describe Color do
  subject(:color) { Color.new(:white,255,255,255) }

  it 'should have a name' do
    expect(color.name).to eq(:white)
  end

  it 'should have values for each channel' do
    expect(color.red).to eq(255)
    expect(color.blue).to eq(255)
    expect(color.green).to eq(255)
  end

  context 'should have some named colors' do
    it 'should have red' do
      expect(Red.name).to eq(:red)
      expect(Red.red).to eq(256)
      expect(Red.blue).to eq(0)
      expect(Red.green).to eq(0)
    end

    it 'should have green' do
      expect(Green.name).to eq(:green)
      expect(Green.red).to eq(0)
      expect(Green.green).to eq(256)
      expect(Green.blue).to eq(0)
    end

    it 'should have blue' do
      expect(Blue.name).to eq(:blue)
      expect(Blue.blue).to eq(256)
      expect(Blue.red).to eq(0)
      expect(Blue.green).to eq(0)
    end
  end
end

describe Mixture do
  subject(:mixture) do
    Mixture.new([Red,Blue])
  end

  let(:mixed_color) { mixture.color }

  it 'should be a color' do
    expect(mixed_color).to be_a(Color)
  end

  it 'should have averaged RGB values' do
    expect(mixed_color.red).to eq(128)
    expect(mixed_color.blue).to eq(128)
  end

  describe '.infer' do
    context 'with a simple combination' do
      subject(:mixture) do
        Mixture.infer(Purple)
      end

      it 'should have source colors Red and Blue' do
        expect(mixture.sources).to eq([Red, Blue])
      end
    end

    context 'with a two-step combination' do
      subject(:mixture) do
        Mixture.infer(Lavender, SimplePalette)
      end

      it 'should have source colors Red and Blue' do
        expect(mixture.sources.map(&:name)).to eq([:white, "red-blue"])
      end
    end

    context 'can mix Peach' do
      subject(:mixture) do
        Mixture.infer(Peach, SimplePalette)
      end

      it 'should have source colors white and white-red-orange' do
        expect(mixture.sources.map(&:name)).to eq([:white, "white-red-orange"])
      end
    end

    context 'can mix Sienna' do
      subject(:mixture) do
        Mixture.infer(Sienna, SimplePalette)
      end

      it 'should have source colors red and green-blue-red-white' do
        binding.pry
        expect(mixture.sources.map(&:name)).to eq([:red, "green-blue-red-white"])
      end
    end
  end
end
