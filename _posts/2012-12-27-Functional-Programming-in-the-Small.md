---
layout: post
title: Functional Programming in the Small
---

This bit of helper code came up in a [Semaphore](http://semaphoreapp.com) code review:

{% highlight ruby %}
def branch_options_for_select
  urls = []

  if @project.branches.empty?
    urls << ["No Branches", ""]
  else
    @project.branches.each do |branch|
      urls << [branch.name, url_for_branch_status(branch)]
    end
  end

  urls
end
{% endhighlight %}

It's written in an unnecessarily imperative style. The first thing that irked me is that it's setting up an empty array and returning it at the end. You can avoid that by using Object#tap like this:

{% highlight ruby %}
def branch_options_for_select
  [].tap do |urls|
    if @project.branches.empty?
      urls << ["No Branches", ""]
    else
      @project.branches.each do |branch|
        urls << [branch.name, url_for_branch_status(branch)]
      end
    end
  end
end
{% endhighlight %}

Tap is an implementation of the [K combinator](http://en.wikipedia.org/wiki/SKI_combinator_calculus) in Ruby. It yields the receiver to a block and returns it when the block returns. We use the block to add elements to the empty array and when the block returns it yields the mutated array.

Since we have two cases, mutating the array seems unnecessary:

1. For every branch we return an array pair of branch name and url
2. There are no branches and we just return an array with a pair "No Branches" and an empty string for the url

We can write this method in a more declarative way:

{% highlight ruby %}
def branch_options_for_select
  if @project.branches.empty?
    [["No Branches", ""]]
  else
    @project.branches.map { |branch| [branch.name, url_for_branch_status(branch)] }
  end
end
{% endhighlight %}

Map is a
[higher order function](http://en.wikipedia.org/wiki/Higher-order_function)
that applies a function to every element of an enumerable, in this
case an array, and returns a new array with the values the function
evaluates to.

This method also relies on the @projects variable. If it's not there or if it's named differently, the helper becomes useless. The last part of the refactoring is parametrizing the helper:

{% highlight ruby %}
def branch_options_for_select(branches)
  if branches.empty?
    [["No Branches", ""]]
  else
    branches.map { |branch| [branch.name, url_for_branch_status(branch)] }
  end
end
{% endhighlight %}

While I'm sure someone could code-golf it some more, the idea is to make methods and helpers more declarative, closer to what you would write in Haskell or Clojure. I should mention that the above helper function is *not* [pure](http://en.wikipedia.org/wiki/Pure_function) since we're using url helpers and they could change if we change our route structure.

But this is close enough for a Rails view helper.
