#!/usr/bin/env ruby
require 'pry'

def get_words
  file = File.open("lotsowords.txt", "r")
  raw_words = file.read.split
  file.close
  raw_words
end

def clean_word(word)
  word = word.downcase
  word = word.gsub(/[^a-z']/i, '')
  word
end

def clean_words(words)
  words = words.map{|word| clean_word(word)}
  words = words.select{|word| word.length > 0}
end

def create_hash
  words = get_words
  words = clean_words(words)
  word_count = count_words(words)
  word_count
end

def count_words(words, word_count_hash = {})
  words.each do |word|
    if word_count_hash[word]
      word_count_hash[word] += 1
    else
      word_count_hash[word] = 1
    end
  end
  word_count_hash
end

def remove_letters(word)
  word_permutations = []
  index = 0
  while index < word.length do
    word_chopped = word.split("")
    word_chopped.delete_at(index)
    word_permutations << word_chopped.join
    index += 1
  end
  word_permutations
end

def add_letters(word)
  word_permutations = []
  index = 0
  while index <= word.length do
    ('a'..'z').to_a.each do |letter|
      word_chopped = word.split("")
      word_chopped.insert(index, letter)
      word_permutations << word_chopped.join
    end
    index += 1
  end
  word_permutations
end

def swap_letters(word)
  word_permutations = []
  index = 0
  while index < (word.length - 1) do
    word_chopped = word.split("")
    word_chopped[index], word_chopped[index + 1] = word_chopped[index + 1], word_chopped[index]
    word_permutations << word_chopped.join
    index += 1
  end
  word_permutations
end

def get_word_permutations(word)
  word = word.downcase
  remove_letters(word) + add_letters(word) + swap_letters(word)
end

def get_matches(permutations)
  matches = {}
  permutations.each do |permutation|
    matches[permutation] = WORD_COUNT[permutation] if WORD_COUNT[permutation]
  end
  matches
end

def get_best_match(matches)
  matches.key(matches.values.max)
end

def match_misspelled_word(word)
  get_best_match(get_matches(get_word_permutations(word)))
end

def is_word?(word)
  !WORD_COUNT[word].nil?
end

def correct(sentence)
  words = sentence.split
  new_words = []
  words.each do |word|
    if is_word?(word)
      new_words << word
    else
      new_words << match_misspelled_word(word)
    end
  end
  new_words.join(" ")
end

WORD_COUNT = create_hash
input = ARGV.join(" ")
puts correct(input)
