module FixtureHelpers
  def read_fixture(name)
    File.read(Rails.root.join('spec', 'fixtures', name))
  end
end
