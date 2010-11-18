# encoding: utf-8
{
  'i nøkkelord-seksjonen' => 'aside.tags',
  'i tittelen' => 'h1',
  'under nåværende versjon' => '.current',
  'under første versjon' => '.version-number-1',
  'i artikkel-lista' => 'table.articles'
}.
each do |within, selector|
  Then /^(.+) #{within}$/ do |step|
    with_scope(selector) do
      Then step
    end
  end
end
