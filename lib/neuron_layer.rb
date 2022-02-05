class NeuronLayer
  attr_reader :neurons, :outputs, :size, :n_inputs, :n_neurons

  def initialize(n_inputs, n_neurons = 1)
    @n_inputs = n_inputs
    @n_neurons = n_neurons

    raise ArgumentError if n_neurons < 1

    @neurons = Array.new(n_neurons) { NeuronNode.new(n_inputs) }
  end

  def activation=(f)
    @neurons.map { |n| n.activation = f }
  end

  def inputs=(inputs)
    @outputs = []

    # raise ArgumentError if length != @n_neurons or inputs.first.to_a.length != @n_inputs

    @neurons.each do |neuron|
      @outputs << neuron.process(inputs)
    end

  end

  def correction(input, answer)
    @neurons.each do |neuron|
      neuron.correction input, answer
    end
  end

  def process(inputs)
    self.inputs = inputs

    self.outputs
  end

  def outputs
    Vector[*@outputs]
  end
end