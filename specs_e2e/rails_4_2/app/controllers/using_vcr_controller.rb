class UsingVcrController < ApplicationController
  def index
  end

  def record_cats
    uri = URI('https://cat-fact.herokuapp.com/facts')
    res = Net::HTTP.get_response(uri)
    @cat_facts = JSON.parse(res.body)
  end
end
