rspec_module = defined?(RSpec::Core) ? 'RSpec' : 'Spec' # RSpec 1 compatability

if rspec_module == 'RSpec'
  require 'rspec/core'
  require 'rspec/expectations'
else
  ActiveSupport::Deprecation
    .warn('RSpec < 3 will not be supported in the CanCanCan >= 2.0.0')
end

Kernel.const_get(rspec_module)::Matchers.define :be_able_to do |*args|
  match do |ability|
    ability.can?(*args)
  end

  # Check that RSpec is < 2.99
  if !respond_to?(:failure_message) && respond_to?(:failure_message_for_should)
    alias :failure_message :failure_message_for_should
    alias :failure_message_when_negated :failure_message_for_should_not
  end

  failure_message do
    resource = args[1]
    if resource.instance_of?(Class)
      "expected to be able to #{args.map(&:to_s).join(' ')}"
    else
      "expected to be able to #{args.map(&:inspect).join(' ')}"
    end
  end

  failure_message_when_negated do
    resource = args[1]
    if resource.instance_of?(Class)
      "expected not to be able to #{args.map(&:to_s).join(' ')}"
    else
      "expected not to be able to #{args.map(&:inspect).join(' ')}"
    end
  end

  description do
    resource = args[1]
    if resource.instance_of?(Class)
      "expected to be able to #{args.map(&:to_s).join(' ')}"
    else
      "expected to be able to #{args.map(&:inspect).join(' ')}"
    end
  end
end
