require 'matrix'

require_relative 'lib/neuron_layer'
require_relative 'lib/neuron_node'
require_relative 'lib/console_output'

N_NEURONS = 2

inputs = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
answers = [-1, 1, 1, -1]

hide_layer = NeuronLayer.new 2, N_NEURONS
output_layer = NeuronNode.new N_NEURONS

hide_layer.neurons.each { |n| n.learning = rand }
hide_layer.neurons.each { |n| n.bias = rand }

output_layer.learning = rand
output_layer.bias = rand

include ConsoleOutput

found = false
time_elapsed = 0

title 'Inputs'

puts "Inputs:\t#{inputs}"

100.times do |t|
  outputs = []

  title "Try #{t}"

  subtitle 'Hide layer'
  puts "Weight:\t#{hide_layer.neurons.map { |n| n.weight.to_a } }"
  puts "Bias:\t#{hide_layer.neurons.map { |n| n.bias } }"

  subtitle 'Output layer'
  puts "Weight:\t#{output_layer.weight}"
  puts "Bias:\t#{output_layer.bias}"

  inputs.length.times do |i|
    output = nil

    time_elapsed = current_time do
      outs = hide_layer.process(inputs[i])
      output = output_layer.process(outs)

      output_layer.correction outs, answers[i]
      hide_layer.correction inputs[i], answers[i]
    end

    outputs << output
  end

  found = answers == outputs

  subtitle 'Other'
  puts "Time elapsed:\t#{time_elapsed}'s"

  next unless found

  title 'Success!'

  subtitle 'Final Output'
  puts "Outputs:\t#{outputs}"
  puts "Answers:\t#{answers}"

  break
end

unless found
  title 'Failure!'
  puts 'Try again with other inputs'
end