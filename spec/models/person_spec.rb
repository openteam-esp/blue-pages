require 'spec_helper'

describe Person do
  it { should normalize_attribute(:info_path).from('').to(nil) }
end
