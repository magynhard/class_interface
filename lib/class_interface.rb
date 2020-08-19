require 'class_interface/version'

require_relative 'custom_errors/implementation_constant_type_error'
require_relative 'custom_errors/implementation_incomplete_error'
require_relative 'custom_errors/implementation_parameter_count_error'
require_relative 'custom_errors/interface_constant_definition_error'
require_relative 'custom_errors/interface_not_defined_error'

#
# Equip classes with the requirement to implement interfaces
#

#
# - ensures self.static methods to be defined (checking parameters count to be equal)
# - ensures instance methods to be defined (checking parameters count to be equal)
# - ensures CONSTANTS to be defined (checking for type of CONSTANTS)
#
# @param interface_constant [Class|String]
def implements(interface_constant)
  implementation_class = extract_caller_path caller_locations(1, 16)
  if Object.const_defined? interface_constant.to_s
    #--------------------------------------------------------------------------
    # check if definitions exist
    #--------------------------------------------------------------------------
    # instance methods
    interface_instance_methods = Object.const_get(interface_constant.to_s).instance_methods false
    implementation_instance_methods = Object.const_get(implementation_class.to_s).instance_methods false
    unimplemented_instance_methods = interface_instance_methods - implementation_instance_methods
    # static methods
    interface_static_methods = Object.const_get(interface_constant.to_s).methods false
    implementation_static_methods = Object.const_get(implementation_class.to_s).methods false
    unimplemented_static_methods = interface_static_methods - implementation_static_methods
    # constants
    interface_constants = Object.const_get(interface_constant.to_s).constants
    implementation_constants = Object.const_get(implementation_class.to_s).constants
    unimplemented_constants = interface_constants - implementation_constants
    if unimplemented_instance_methods.any? || unimplemented_static_methods.any? || unimplemented_constants.any?
      error_message = "\nThe interface '#{interface_constant}' was not completely implemented in class '#{implementation_class}'."
      error_message += "\n  - missing instance methods:\n      #{unimplemented_instance_methods.join(' ')}" if unimplemented_instance_methods.any?
      error_message += "\n  - missing static methods:\n      #{unimplemented_static_methods.join(' ')}" if unimplemented_static_methods.any?
      error_message += "\n  - missing constants:\n      #{unimplemented_constants.join(' ')}" if unimplemented_constants.any?
      raise ClassInterface::ImplementationIncompleteError, error_message
    end

    #--------------------------------------------------------------------------
    # check if method parameters count does match on implementation and interface
    #--------------------------------------------------------------------------
    interface_instance_methods.each do |method_name|
      if_params_count_arity = Object.const_get(interface_constant.to_s).new.method(method_name).arity
      impl_params_count_arity = Object.const_get(implementation_class).new.method(method_name).arity
      if if_params_count_arity != impl_params_count_arity
        raise ClassInterface::ImplementationParameterCountError, "Parameters of instance method '#{implementation_class}##{method_name}' do not match with interface '#{interface_constant}##{method_name}' (given #{impl_params_count_arity.abs}, expected #{if_params_count_arity.abs})"
      end
    end
    interface_static_methods.each do |method_name|
      if_params_count_arity = Object.const_get(interface_constant.to_s).method(method_name).arity
      impl_params_count_arity = Object.const_get(implementation_class).method(method_name).arity
      if if_params_count_arity != impl_params_count_arity
        raise ClassInterface::ImplementationParameterCountError, "Parameters of static method '#{implementation_class}##{method_name}' do not match with interface '#{interface_constant}##{method_name}' (given #{impl_params_count_arity.abs}, expected #{if_params_count_arity.abs})"
      end
    end

    #--------------------------------------------------------------------------
    # check if class types of CONSTANTS do match
    #--------------------------------------------------------------------------
    invalid_const_definitions = []
    if_const_class_type = nil
    interface_constants.each do |const_name|
      if_const_string = "%s::%s" % [interface_constant, const_name]
      if_const_class_type = Object.const_get(if_const_string)
      if_const_class_type = Object.const_get(if_const_string).class unless Object.const_get(if_const_string).class == Class
      invalid_const_definitions += [const_name] unless if_const_class_type.class == Class
      next if if_const_class_type.to_s == 'NilClass'
      impl_const_value_type = Object.const_get("%s::%s" % [implementation_class, const_name]).class
      ruby_version_lt_24 = (1.class.to_s == 'Fixnum')
      ruby_version_gte_24 = (1.class.to_s == 'Integer')
      # Ruby < 2.4
      if ruby_version_lt_24 && if_const_class_type.to_s == 'Numeric' && %w[Fixnum Float Bignum].include?(impl_const_value_type.to_s)
        # we are fine, specific case for numbers
      # Ruby => 2.4
      elsif ruby_version_gte_24 && if_const_class_type.to_s == 'Numeric' && %w[Integer Float].include?(impl_const_value_type.to_s)
        # we are fine, specific case for numbers
      elsif ruby_version_lt_24 && ((if_const_class_type.to_s == 'Bignum' && impl_const_value_type.to_s == 'Integer') ||
          (if_const_class_type.to_s == 'Fixnum' && impl_const_value_type.to_s == 'Integer') ||
          (if_const_class_type.to_s == 'Integer' && impl_const_value_type.to_s == 'Fixnum') ||
          (if_const_class_type.to_s == 'Integer' && impl_const_value_type.to_s == 'Bignum'))
        # Ruby 2.4 unifies Fixnum and Bignum into Integer
      elsif if_const_class_type != impl_const_value_type
        raise ClassInterface::ImplementationConstantTypeError, "Value type of constant '#{implementation_class}::#{const_name}' does not match interface '#{if_const_string}'. (#{impl_const_value_type} given, #{if_const_class_type} expected)"
      end
    end
    raise ClassInterface::InterfaceConstantDefinitionError, "Value of constant(s) '#{invalid_const_definitions.join(" ")}' of interface '#{interface_constant}' must be a class constant or nil" if invalid_const_definitions.any?
  else
    raise ClassInterface::InterfaceNotDefinedError, "Interface '#{interface_constant}' is not defined"
  end
end


# extracts the (module) class name of the caller
# e.g. ModuleName::ClassName
#
# @param caller_locations [Array<Thread::Backtrace::Location>] array containing the result of caller_locations
# @return [String] full specified constant class name
def extract_caller_path(caller_locations)
  path_elements = []
  caller_locations.each do |el|
    if el.label.start_with?('<class:') || el.label.start_with?('<module:')
      name = el.label.gsub(/\<class:|\<module:/, '')[0...-1]
      path_elements.push name
    end
  end
  path_elements.reverse.join("::")
end