def word_distance w1, w2
  w1_letters = w1.split('')
  w2_letters = w2.split('')
  w1_letters.each_with_index.inject(0) do |m,(l,i)|
    m += 1 unless l == w2_letters[i]
    m
  end
end

def commons w1, w2
  w1_letters = w1.split('')
  w2_letters = w2.split('')
  w1_letters.each_with_index.inject('') do |m,(l,i)|
    m << l if l == w2_letters[i]
    m
  end
end

def common_letters values
  while current_word = values.shift do
    values.each do |other_word|
      return commons(current_word, other_word) if word_distance(current_word, other_word) == 1
    end
  end
end

if __FILE__ == $0
  values = File.open("#{__dir__}/input.txt",'r').readlines
  puts common_letters(values)
end