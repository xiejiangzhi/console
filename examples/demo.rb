#! /usr/bin/env ruby
#
require 'bundler/setup'
require 'console'

class Demo
  include Console

  define_cmd(:hello, "print hello") do
    puts "hello #{`whoami`}"
  end

  define_cmd(:rand, "output rand number") do |max = 100|
    puts rand(max.to_i)
  end

  define_cmd(:incr, "increment number") do |i = 1|
    @incr_number ||= 0
    puts @incr_number += i.to_i
  end
end

Demo.new.start("demo > ")

