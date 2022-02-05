#!/usr/bin/ruby
require 'matrix'

require_relative 'lib/neuron_layer'
require_relative 'lib/neuron_node'

node = NeuronNode.new 2

inputs = [[0, 0], [0, 1], [1, 0], [1, 1]]
answers = [0, 0, 0, 1]
umbral = 0.5

node.bias = 0.5
node.learning = 0.1
node.activation = lambda do |x|
  if x > umbral
    1
  else
    0
  end
end

100.times do
  steps = inputs.length
  outs = []

  steps.times do |i|
    out = node.process inputs[i]

    node.correction inputs[i], answers[i]

    outs << out
  end

  puts '-' * 80

  puts "Answers: #{answers}"
  puts "Outputs: #{outs}"
  puts "Weight: #{node.weight.to_a}"
  puts "Bias: #{node.bias}"

  break if answers == outs
end