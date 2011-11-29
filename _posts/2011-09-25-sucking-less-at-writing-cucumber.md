---
layout: post
title: Sucking Less at Writing Cucumber
date: 30-11-2011
---

I wrote my first [Cucumber](http://cukes.info/) scenario about five months ago. It went something like this:

{% highlight cucumber %}
Scenario: Changing email
  Given I am logged in
  And I an on the homepage
  When I click on "Account"
  And I fill in "email" with "milos@example.com"
  And I press "Change Email"
  Then I should see "Email successfully changed"
  When I visit "My profile page"
  Then I should see "milos@example.com"
{% endhighlight %}

Maybe my *naivete* was not solely to blame; I was told it was so easy "that it could be taught to a secretary". I am not so sure anymore.

Some of the problems with the above scenario are:

* It's too long and verbose
* It's not using the *domain language*

Read the scenario. As a reader, why do I need to have a mental model of that web site to be able to follow it? Couldn't it be replaced with:

{% highlight cucumber %}
Background:
  Given I am logged in
{% endhighlight %}
{% highlight cucumber %}
Scenario: Changing Email
  Given I am on my account page
  When I change my email
  Then I should see that my email has changed
{% endhighlight %}

Using web steps makes you write very imperative scenarios that you have to rewrite each time you change something. It's actually one of the reasons why they were removed from the latest version of cucumber. People used them too much and wrote shitty scenarios. I'm not sure I agree with the descision to completely remove them but I can undestand. [The pull request](https://github.com/cucumber/cucumber-rails/issues/174) now serves as an explicit note that you should be writing declarative steps.

A good indicator that your scenario is not good is if you change something in your implementation and you have to change the scenario. You'll probably need to change your step definition anyway but the *Gherkin* stuff should be as decoupled from the implementation as possible. In the above scenario:

1. How I change my email is an implementation detail and belongs in the step definition
2. How I see that my email really changed is also an implementation detail

We still test if this whole system works but if I change how it works I only need to change the step definitions. The scenario stays the same.

Lately I just write the whole scenario and implement the steps. I only reuse steps if I see that the one I had just written is similar in wording to some step I had written before. The added benefit of this is that I now know capybara much more intimately than before. [Capybara](https://github.com/jnicklas/capybara) is very powerful and much nicer to work with than web steps.
