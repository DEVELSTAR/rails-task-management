# spec/factories/cat_facts.rb
FactoryBot.define do
  factory :cat_fact do
    fact { "Cats purr to communicate." }
    source { "catfact.ninja" }
  end
end
