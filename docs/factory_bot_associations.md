# Setting up associations with the correct data

You cannot access associations directly from Cypress like you can do with ruby tests.
So setting up associations has to be done differently from within Cypress.

There are a few ways you can setup associations with the correct data using Cypress and FactoryBot.
1. Setting the foreign keys
2. Using transient attributes
3. Using Nested Attributes
4. Combination of the above depending on your situation

Assuming you have the following models

```rb
class Post < ApplicationRecord
  belongs_to :author
  accepts_nested_attributes_for :author
end

class Author < ApplicationRecord
  has_many :posts
  accepts_nested_attributes_for :posts
end
```

You can do the following:

## 1. Setting the foreign keys

factories.rb
```rb
FactoryBot.define do
  factory :author do
    name { 'Taylor' }
  end

  factory :post do
    title { 'Cypress on Rails is Awesome' }
    author_id { create(:author).id }
  end
end
```

then in Cypress
```js
// example with overriding the defaults
cy.appFactories([['create', 'author', { name: 'James' }]]).then((records) => {
  cy.appFactories([['create', 'post', { title: 'Cypress is cool', author_id: records[0].id }]]
});

// example without overriding anything
cy.appFactories([['create', 'author']]).then((records) => {
  cy.appFactories([['create', 'post', { author_id: records[0].id }]]
});
```

## 2. Using transient attributes

```rb
FactoryBot.define do
  factory :author do
    name { 'Taylor' }
  end

  factory :post do
    transient do
      author_name { 'Taylor' }
    end
    title { 'Cypress on Rails is Awesome' }
    author { create(:author, name: author_name ) }
  end
end
```

then in Cypress
```js
// example with overriding the defaults
cy.appFactories([['create', 'post', { title: 'Cypress is cool', author_name: 'James' }]]

// example without overriding
cy.appFactories([['create', 'post']]
```

## 3. Using Nested Attributes

```rb
FactoryBot.define do
  factory :author do
    name { 'Taylor' }
  end

  factory :post do
    title { 'Cypress on Rails is Awesome' }
    author_attributes { { name: 'Taylor' } }
  end
end
```

then in Cypress
```js
// example with overriding the defaults
cy.appFactories([['create', 'post', { title: 'Cypress is cool', author_attributes: { name: 'James' } }]]

// example without overriding
cy.appFactories([['create', 'post']]

// example of creating author with multiple posts
cy.appFactories([['create', 'author', { name: 'James', posts_attributes: [{ name: 'Cypress is cool' }, {name: 'Rails is awesome' }] ]]
```
