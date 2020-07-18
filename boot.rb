require 'rubygems'
require 'bundler'

Bundler.require

Dir['./app/**/*.rb'].each { |file| require file }
require './blog_app'
