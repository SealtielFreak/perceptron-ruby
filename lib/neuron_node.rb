class NeuronNode
  attr_reader :output
  attr_accessor :weight, :bias, :activation, :learning

  def initialize(n_inputs, weight = nil, bias = 0, activation = nil)
    @n_inputs = n_inputs
    @bias = bias
    @learning = 1

    @weight = if weight.nil?
                Vector[*Array.new(n_inputs, 0)]
              else
                weight
              end

    @activation = if activation.nil?
                    lambda do |x|
                      if x >= 0
                        1
                      else
                        -1
                      end
                    end
                  else
                    activation
                  end

  end

  def inputs=(input)
    length = input.to_a.length

    raise ArgumentError if length != @weight.count

    @output = @activation.call(Array.new(length) { |i| (input[i] * @weight[i]) }.sum + @bias)
  end

  def correction(input, answer)
    err = (answer - @output) * @learning

    return err unless err != 0

    @weight.count.times { |j| @weight[j] += err * input[j] }
    @bias += err

    err
  end

  def process(input)
    self.inputs = input

    @output
  end
end