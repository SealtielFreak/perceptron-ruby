require 'matrix'

require_relative 'lib/neuron_layer'
require_relative 'lib/neuron_node'
require_relative 'lib/console_output'

N_NEURONS = 2

inputs = [[0, 0], [0, 1], [1, 0], [1, 1]]
answers = [0, 1, 1, 0]
error_t = 0

hide_layer = NeuronLayer.new inputs.first.length, N_NEURONS
output_layer = NeuronNode.new N_NEURONS

hide_layer.neurons.each { |n| n.weight = Array.new(hide_layer.n_inputs) { rand } }
hide_layer.neurons.each { |n| n.learning = rand }
hide_layer.neurons.each { |n| n.bias = rand }

output_layer.weight.map! { rand }
output_layer.learning = rand
output_layer.bias = rand

activation = lambda { |x| 1.0 / (1 + Math::E ** -x) }

hide_layer.activation = activation
output_layer.activation = activation

include ConsoleOutput

found = false
time_elapsed = 0
outputs = []

title 'Inputs'

puts "Inputs:\t#{inputs}"

begin
  1000.times do |t|
    error = []

    title "Try #{t}"

    outputs.clear

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

      error << ((answers[i] - output) / output).abs

      outputs << output
    end

    err_relative = error.sum / error.length
    found = answers == outputs || err_relative <= error_t

    subtitle 'Time'
    puts "Time elapsed:\t#{time_elapsed}'s"

    subtitle 'Errors'
    error.each { |e| puts "Error: #{'%.4f' % e}%" }
    puts "Average error: #{'%.3f' % err_relative} %"

    break if found
  end

rescue Interrupt
  message 'Interrupt loop!'
end

if found
  title 'Success!'
else
  title 'Failure?'
  puts 'Try again'
end

if outputs.length == 4
  subtitle 'Final Output'
  puts "Outputs:\t#{outputs}"
  puts "Answers:\t#{answers}"
end