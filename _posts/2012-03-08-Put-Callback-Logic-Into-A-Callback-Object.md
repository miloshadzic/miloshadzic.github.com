---
layout: post
title: Put Callback Logic Into Callback Objects
date: 8-3-2012
---

I've recently needed to generate a unique hash id for every new record in the database. The usual way I would do it would be by defining methods on a model and passing a method symbol to before_validation like this:

{% highlight ruby %}
# app/models/request.rb
class Request < ActiveRecord::Base
  before_validation :generate_hash_id, :on => :create

  def generate_hash_id
    hash_id = SecureRandom.hex(12) until has_unique_hash_id?
  end

  def has_unique_hash_id?
    exists?(:hash_id => hash_id)
  end
end
{% endhighlight %}

That may look alright but I'd rather have just the unavoidable logic in my ActiveRecord models. One reason being that I'd like my tests to be fast and the other is that I'm probably going to use this generator on a different model so I'm probably better off reusing this.

Rails callbacks can take a method, an *object* or a Proc. The idea here is to create a callback object and move all the logic there. Your callback object should have a method with the same name as the callback and take a record as a parameter. Here's what it looks like.

{% highlight ruby %}
# app/models/request.rb
class Request < ActiveRecord::Base
  before_validation HashGenerator.new(self), :on => :create
end
{% endhighlight %}


Pretty barren. Let's look at HashGenerator.


{% highlight ruby %}
# app/callbacks/hash_generator.rb
require 'securerandom'

class HashGenerator
  def initialize(model, opts={})
    @model  = model
    @field  = opts['db_field']  || "hash_id"
    @length = opts['length']    || 12
    @hash   = generate_hash
  end

  def before_validation(record)
    # this doesn't scale very well but let's ignore it for now
    @hash = generate_hash until hash_unique?
    record.send(@field+"=", @hash)
  end

  private

  def generate_hash
    SecureRandom.hex(@length)
  end

  def hash_unique?
    !@model.exists?(@field => @hash)
  end
end
{% endhighlight %}

While I don't need it right away, I made the hash length and the underlying db_field changeable with an options hash.

The way I see it, this way you have a lot less logic in your ActiveRecord model. A lovely side-effect is that your logic is now in a plain Ruby object and your spec doesn't need to require spec_helper. Your specs for this functionality run superfast.

I think I'll be creating callback objects for most callbacks.  It seems like a really cheap way to thin out models even more.

The only bad thing I see is that there's a bit more code, but I can live with that.

[Hacker News thread for comments →](http://news.ycombinator.com/item?id=3679333)
