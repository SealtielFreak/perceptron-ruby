require 'colorize'

def current_time(&block)
  last = Time.now

  block.call

  Time.now - last
end

module ConsoleOutput
  def bar
    puts '-' * 80
  end

  def title(txt, chr = '*', color = :red)
    txt = "[#{txt}]".colorize :bold

    puts "\n#{chr * 15 + txt + chr * (65 - txt.length)}".colorize color
  end

  def subtitle(txt, color = :green)
    txt = "(#{txt})".colorize :bold

    puts "#{'-' * 15 + txt + '-' * (65 - txt.length)}".colorize color
  end

  def error(txt) end
end