# encoding: utf-8
{
  'i nøkkelord-seksjonen' => 'aside.tags',
  'i tittelen' => 'h1'
}.
each do |within, selector|
  Then /^(.+) #{within}$/ do |step|
    with_scope(selector) do
      Then step
    end
  end
end
