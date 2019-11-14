require 'spec_helper'
require 'ostruct'

RSpec.describe ClassInterface do
  it "has a version number" do
    expect(ClassInterface::VERSION).not_to be nil
  end
end

$ruby_version_lt_24 = (1.class.to_s == 'Fixnum')
$ruby_version_gte_24 = (1.class.to_s == 'Integer')

if $ruby_version_lt_24
  puts "Ruby < 2.4"
else
  puts "Ruby >= 2.4"
end

RSpec.describe '#implements' do
  context 'Implement interfaces - constants - positive cases' do
    it 'implement an interface without any constants or methods' do
      class IEmpty
      end
      expect {
        class Empty
          implements IEmpty
        end
      }.not_to raise_error
    end
    it 'implement an interface with only one constant of type nil using String' do
      class IConstant1
        ONE_CONSTANT = nil
      end
      expect {
        class Constant1
          ONE_CONSTANT = "string"
          implements IConstant1
        end
      }.not_to raise_error
    end
    it 'implement an interface with only one constant of type nil using Array' do
      class IConstant2
        ONE_CONSTANT = nil
      end
      expect {
        class Constant2
          ONE_CONSTANT = [1, 2, "three"]
          implements IConstant2
        end
      }.not_to raise_error
    end
    it 'implement an interface with only one constant of type nil using Hash' do
      class IConstant3
        ONE_CONSTANT = nil
      end
      expect {
        class Constant3
          ONE_CONSTANT = {one: 1, two: "two", three: [1, 2, "three"]}
          implements IConstant3
        end
      }.not_to raise_error
    end
    it 'implement an interface with only one constant of type nil using nil' do
      class IConstant4
        ONE_CONSTANT = nil
      end
      expect {
        class Constant4
          ONE_CONSTANT = nil
          implements IConstant4
        end
      }.not_to raise_error
    end
    it 'implement an interface with only one constant of type String using string' do
      class IConstant9
        ONE_CONSTANT = ""
      end
      expect {
        class Constant9
          ONE_CONSTANT = "valid_string"
          implements IConstant9
        end
      }.not_to raise_error
    end
    it 'implement an interface with only one constant of type String using string' do
      class IConstant10
        ONE_CONSTANT = String
      end
      expect {
        class Constant10
          ONE_CONSTANT = "valid_string"
          implements IConstant10
        end
      }.not_to raise_error
    end
    it 'implement an interface with only one constant of type Array using array' do
      class IConstant11
        ONE_CONSTANT = Array
      end
      expect {
        class Constant11
          ONE_CONSTANT = [1, 2, "three"]
          implements IConstant11
        end
      }.not_to raise_error
    end
    it 'implement an interface with only one constant of type Array using []' do
      class IConstant12
        ONE_CONSTANT = []
      end
      expect {
        class Constant12
          ONE_CONSTANT = [1, 2, "three"]
          implements IConstant12
        end
      }.not_to raise_error
    end
    it 'implement an interface with only one constant of type Hash using hash' do
      class IConstant13
        ONE_CONSTANT = Hash
      end
      expect {
        class Constant13
          ONE_CONSTANT = {some: "thing"}
          implements IConstant13
        end
      }.not_to raise_error
    end
    it 'implement an interface with only one constant of type Hash using {}' do
      class IConstant14
        ONE_CONSTANT = {}
      end
      expect {
        class Constant14
          ONE_CONSTANT = {some: "thing"}
          implements IConstant14
        end
      }.not_to raise_error
    end
    it 'implement an interface with only one constant of type Numeric using Integer' do
      class IConstant15
        ONE_CONSTANT = Numeric
      end
      expect {
        class Constant15
          ONE_CONSTANT = 1
          implements IConstant15
        end
      }.not_to raise_error
    end
    it 'implement an interface with only one constant of type Numeric using Float' do
      class IConstant16
        ONE_CONSTANT = Numeric
      end
      expect {
        class Constant16
          ONE_CONSTANT = 1.2
          implements IConstant16
        end
      }.not_to raise_error
    end
    it 'implement an interface with only one constant of type Numeric using bignum(<2.4)/integer(>=2.4)' do
      class IConstant17
        ONE_CONSTANT = Numeric
      end
      expect {
        class Constant17
          ONE_CONSTANT = 100 ** 100
          implements IConstant17
        end
      }.not_to raise_error
    end
    it 'implement an interface with only one constant of type Integer using integer' do
      class IConstant18
        ONE_CONSTANT = Integer
      end
      expect {
        class Constant18
          ONE_CONSTANT = 10
          implements IConstant18
        end
      }.not_to raise_error
    end
    it 'implement an interface with only one constant of type Float using float' do
      class IConstant19
        ONE_CONSTANT = Float
      end
      expect {
        class Constant19
          ONE_CONSTANT = 10.20
          implements IConstant19
        end
      }.not_to raise_error
    end
    it 'implement an interface with only one constant of type Bignum using big number' do
      class IConstant20
        ONE_CONSTANT = if $ruby_version_lt_24
                         Bignum
                       else
                         Integer
                       end
      end
      expect {
        class Constant20
          ONE_CONSTANT = 100 ** 100
          implements IConstant20
        end
      }.not_to raise_error
    end
  end

  context 'Implement interfaces - constants - negative cases' do
    it 'implement an interface without any constants or methods' do
      class INotEmpty
        NOT_EMPTY = nil
      end
      expect {
        class Empty1
          implements INotEmpty
        end
      }.to raise_error ClassInterface::ImplementationIncompleteError
    end
    it 'implement an interface with only one constant of type String, but implement Number' do
      class IConstantNegative
        ONE_CONSTANT = String
      end
      expect {
        class ConstantNegative
          ONE_CONSTANT = 1
          implements IConstantNegative
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type String, implementing array' do
      class IConstantNegative10
        ONE_CONSTANT = String
      end
      expect {
        class ConstantNegative10
          ONE_CONSTANT = []
          implements IConstantNegative10
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Array, implementing string' do
      class IConstantNegative11
        ONE_CONSTANT = Array
      end
      expect {
        class ConstantNegative11
          ONE_CONSTANT = "1"
          implements IConstantNegative11
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Array, implementing hash' do
      class IConstantNegative12
        ONE_CONSTANT = []
      end
      expect {
        class ConstantNegative12
          ONE_CONSTANT = {a: "b"}
          implements IConstantNegative12
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Hash, implementing string' do
      class IConstantNegative13
        ONE_CONSTANT = Hash
      end
      expect {
        class ConstantNegative13
          ONE_CONSTANT = "thing"
          implements IConstantNegative13
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Hash, implementing array' do
      class IConstantNegative14
        ONE_CONSTANT = {}
      end
      expect {
        class ConstantNegative14
          ONE_CONSTANT = ["thing"]
          implements IConstantNegative14
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Numeric, implementing string' do
      class IConstantNegative15
        ONE_CONSTANT = Numeric
      end
      expect {
        class ConstantNegative15
          ONE_CONSTANT = "1"
          implements IConstantNegative15
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Numeric, implementing array' do
      class IConstantNegative16
        ONE_CONSTANT = Numeric
      end
      expect {
        class ConstantNegative16
          ONE_CONSTANT = [1, 2, 3]
          implements IConstantNegative16
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Numeric, implementing hash' do
      class IConstantNegative17
        ONE_CONSTANT = Numeric
      end
      expect {
        class ConstantNegative17
          ONE_CONSTANT = {c: "d"}
          implements IConstantNegative17
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Integer, implementing float' do
      class IConstantNegative18
        ONE_CONSTANT = Integer
      end
      expect {
        class ConstantNegative18
          ONE_CONSTANT = 10.20
          implements IConstantNegative18
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Float, implementing Integer' do
      class IConstantNegative19
        ONE_CONSTANT = Float
      end
      expect {
        class ConstantNegative19
          ONE_CONSTANT = 10
          implements IConstantNegative19
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Bignum, implementing Float' do
      class IConstantNegative20
        ONE_CONSTANT = if $ruby_version_lt_24
                         Bignum
                       else
                         Integer
                       end
      end
      expect {
        class ConstantNegative20
          ONE_CONSTANT = 100.200
          implements IConstantNegative20
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type String, implementing Integer' do
      class IConstantNegative30
        ONE_CONSTANT = String
      end
      expect {
        class ConstantNegative30
          ONE_CONSTANT = 2
          implements IConstantNegative30
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Array, implementing hash' do
      class IConstantNegative31
        ONE_CONSTANT = Array
      end
      expect {
        class ConstantNegative31
          ONE_CONSTANT = {f: "g"}
          implements IConstantNegative31
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Array, implementing Integer' do
      class IConstantNegative32
        ONE_CONSTANT = []
      end
      expect {
        class ConstantNegative32
          ONE_CONSTANT = 33
          implements IConstantNegative32
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Hash, implementing string' do
      class IConstantNegative33
        ONE_CONSTANT = Hash
      end
      expect {
        class ConstantNegative33
          ONE_CONSTANT = "Hash"
          implements IConstantNegative33
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Hash, implementing float' do
      class IConstantNegative34
        ONE_CONSTANT = {}
      end
      expect {
        class ConstantNegative34
          ONE_CONSTANT = 1.23
          implements IConstantNegative34
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Numeric, implementing string' do
      class IConstantNegative35
        ONE_CONSTANT = Numeric
      end
      expect {
        class ConstantNegative35
          ONE_CONSTANT = "1"
          implements IConstantNegative35
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Numeric, implementing array' do
      class IConstantNegative36
        ONE_CONSTANT = Numeric
      end
      expect {
        class ConstantNegative36
          ONE_CONSTANT = [1.2]
          implements IConstantNegative36
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Numeric, implementing hash' do
      class IConstantNegative37
        ONE_CONSTANT = Numeric
      end
      expect {
        class ConstantNegative37
          ONE_CONSTANT = {a: 100 ** 100}
          implements IConstantNegative37
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Integer, implementing string' do
      class IConstantNegative38
        ONE_CONSTANT = Integer
      end
      expect {
        class ConstantNegative38
          ONE_CONSTANT = "10"
          implements IConstantNegative38
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Float, implementing string' do
      class IConstantNegative39
        ONE_CONSTANT = Float
      end
      expect {
        class ConstantNegative39
          ONE_CONSTANT = "10.20"
          implements IConstantNegative39
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
    it 'implement an interface with only one constant of type Bignum, implementing array' do
      class IConstantNegative40
        ONE_CONSTANT = if $ruby_version_lt_24
                         Bignum
                       else
                         Integer
                       end
      end
      expect {
        class ConstantNegative40
          ONE_CONSTANT = [100 ** 100]
          implements IConstantNegative40
        end
      }.to raise_error ClassInterface::ImplementationConstantTypeError
    end
  end

  context 'Implement interfaces - methods - positive cases' do
    it 'implements an interface with one method' do
      class IOneMethodClass
        def one_method
        end
      end
      expect {
        class OneMethodClass
          def one_method
          end

          implements IOneMethodClass
        end
      }.not_to raise_error
    end
    it 'implements an interface with one method and one parameter' do
      class IOneMethodAndOneParamClass
        def one_method(param1)
        end
      end
      expect {
        class OneMethodAndOneParamClass
          def one_method(param1)
          end

          implements IOneMethodAndOneParamClass
        end
      }.not_to raise_error
    end
    it 'implements an interface with one method and 2 parameters' do
      class IMethodAndParamsClass1
        def one_method(param1, param2)
        end
      end
      expect {
        class MethodAndParamsClass1
          def one_method(param1, param2)
          end

          implements IMethodAndParamsClass1
        end
      }.not_to raise_error
    end
    it 'implements an interface with one method and 3 parameters' do
      class IMethodAndParamsClass2
        def one_method(param1, param2, param3)
        end
      end
      expect {
        class MethodAndParamsClass2
          def one_method(param1, param2, param3)
          end

          implements IMethodAndParamsClass2
        end
      }.not_to raise_error
    end
    it 'implements an interface with one method and 4 parameters' do
      class IMethodAndParamsClass3
        def one_method(param1, param2, param3, params4)
        end
      end
      expect {
        class MethodAndParamsClass3
          def one_method(param1, param2, param3, params4)
          end

          implements IMethodAndParamsClass3
        end
      }.not_to raise_error
    end
    it 'implements an interface with one method and 4 parameters + block' do
      class IMethodAndParamsClass4
        def one_method(param1, param2, param3, params4, &block)
        end
      end
      expect {
        class MethodAndParamsClass4
          def one_method(param1, param2, param3, params4, &block)
          end

          implements IMethodAndParamsClass4
        end
      }.not_to raise_error
    end
  end

  context 'Implement interfaces - methods - negative cases' do
    it 'implements an interface with one instance method with static method' do
      class IOneMethodClassNegative
        def one_method
        end
      end
      expect {
        class OneMethodClassNegative
          def self.one_method
          end

          implements IOneMethodClassNegative
        end
      }.to raise_error ClassInterface::ImplementationIncompleteError
    end
    it 'implements an interface with one method and one parameter with two parameters' do
      class IOneMethodAndOneParamClassNegative
        def one_method(param1)
        end
      end
      expect {
        class OneMethodAndOneParamClassNegative
          def one_method(param1, param2)
          end

          implements IOneMethodAndOneParamClassNegative
        end
      }.to raise_error ClassInterface::ImplementationParameterCountError
    end
    it 'implements an interface with one method and 2 parameters with 1 parameter' do
      class IMethodAndParamsClass1Negative
        def one_method(param1, param2)
        end
      end
      expect {
        class MethodAndParamsClass1Negative
          def one_method(param1)
          end

          implements IMethodAndParamsClass1Negative
        end
      }.to raise_error ClassInterface::ImplementationParameterCountError
    end
    it 'implements an interface with one method and 3 parameters without parameters' do
      class IMethodAndParamsClass2Negative
        def one_method(param1, param2, param3)
        end
      end
      expect {
        class MethodAndParamsClass2Negative
          def one_method
          end

          implements IMethodAndParamsClass2Negative
        end
      }.to raise_error ClassInterface::ImplementationParameterCountError
    end
    it 'implements an interface with one method and 4 parameters with one block' do
      class IMethodAndParamsClass3Negative
        def one_method(param1, param2, param3, params4)
        end
      end
      expect {
        class MethodAndParamsClass3Negative
          def one_method(&param1)
          end

          implements IMethodAndParamsClass3Negative
        end
      }.to raise_error ClassInterface::ImplementationParameterCountError
    end
    it 'implements an interface with one method and 4 parameters + block with 3 parameters + block' do
      class IMethodAndParamsClass4Negative
        def one_method(param1, param2, param3, params4, &block)
        end
      end
      expect {
        class MethodAndParamsClass4Negative
          def one_method(param1, param2, param3, &block)
          end

          implements IMethodAndParamsClass4Negative
        end
      }.to raise_error ClassInterface::ImplementationParameterCountError
    end
  end

  context 'Implement mixed' do
    it 'implements an interface, using string name' do
      class IStringImpl
      end
      expect {
        class StringImpl
          implements 'IStringImpl'
        end
      }.not_to raise_error
    end
    it 'implements an nested interface, using constant name' do
      module INestedC
        class IStringInNestC
          def nested_method
          end
        end
      end
      expect {
        class StringImplC
          def nested_method
          end

          implements INestedC::IStringInNestC
        end
      }.not_to raise_error
    end
    it 'implements an nested interface, using string name' do
      module INestedS
        class IStringInNestS
          def nested_method
          end
        end
      end
      expect {
        class StringImpl1
          def nested_method
          end

          implements "INestedS::IStringInNestS"
        end
      }.not_to raise_error
    end
    it 'implements an nested interface in an invalid way, using string name' do
      module INestedS2
        class IStringInNestS2
          def nested_method
          end
        end
      end
      expect {
        class StringImpl2
          def untested_method
          end

          implements "INestedS2::IStringInNestS2"
        end
      }.to raise_error ClassInterface::ImplementationIncompleteError
    end
    it 'implements an double nested interface in an invalid way, using constant name' do
      module INestedOuter3
        module INestedS3
          class IStringInNestS3
            def nested_method3
            end
          end
        end
      end
      expect {
        class StringImpl3
          def untested_method3
          end

          implements "INestedOuter3::INestedS3::IStringInNestS3"
        end
      }.to raise_error ClassInterface::ImplementationIncompleteError
    end
    it 'implements an interface, using nested class implementation' do
      class IStringImplNX
        def class_nester_x
        end
      end
      expect {
        module ClassNesterX
          class StringImplNX
            def class_nester_x
            end

            implements 'IStringImplNX'
          end
        end
      }.not_to raise_error
    end
    it 'implements an interface, using string that does not exist' do
      expect {
        module ClassNesterY
          class StringImplNY
            def class_nester_y
            end

            implements 'INeverDefined'
          end
        end
      }.to raise_error ClassInterface::InterfaceNotDefinedError
    end
    it 'implements an interface in an invalid way, using nested class implementation' do
      class IStringImplNZ
        def class_nester_z
        end
      end
      expect {
        module ClassNesterZ
          class StringImplNZ
            def class_foo_z
            end

            implements 'IStringImplNZ'
          end
        end
      }.to raise_error ClassInterface::ImplementationIncompleteError
    end
    it 'implements an interface in an invalid way, using double nested class implementation' do
      class IStringImplN2
        def class_nester
        end
      end
      expect {
        module ClassNesterOuter2
          module ClassNester2
            class StringImplN
              def class_foo
              end

              implements 'IStringImplN2'
            end
          end
        end
      }.to raise_error ClassInterface::ImplementationIncompleteError
    end
  end
end


RSpec.describe '#extract_caller_path' do
  context 'Check extractor' do
    it 'can extract a simple class' do
      stack_trace = [
          OpenStruct.new(label: '<class:SimpleClass>'),
          OpenStruct.new(label: '<top (required)>'),
          OpenStruct.new(label: '`matches?')
      ]
      expect(extract_caller_path stack_trace).to eql("SimpleClass")
    end
    it 'can extract a 1 level nested class' do
      stack_trace = [
          OpenStruct.new(label: '<class:SimpleClass>'),
          OpenStruct.new(label: '<module:ParentModule>'),
          OpenStruct.new(label: '<top (required)>'),
          OpenStruct.new(label: '`matches?')
      ]
      expect(extract_caller_path stack_trace).to eql("ParentModule::SimpleClass")
    end
    it 'can extract a 2 level nested class' do
      stack_trace = [
          OpenStruct.new(label: '<class:SimpleClass>'),
          OpenStruct.new(label: '<module:ParentModule>'),
          OpenStruct.new(label: '<module:SuperModule>'),
          OpenStruct.new(label: '<top (required)>'),
          OpenStruct.new(label: '`matches?')
      ]
      expect(extract_caller_path stack_trace).to eql("SuperModule::ParentModule::SimpleClass")
    end
    it 'can extract a 4 level nested class' do
      stack_trace = [
          OpenStruct.new(label: '<class:SimpleClass>'),
          OpenStruct.new(label: '<module:ParentModule>'),
          OpenStruct.new(label: '<module:SuperModule>'),
          OpenStruct.new(label: '<module:MegaSuperModule>'),
          OpenStruct.new(label: '<top (required)>'),
          OpenStruct.new(label: '`matches?')
      ]
      expect(extract_caller_path stack_trace).to eql("MegaSuperModule::SuperModule::ParentModule::SimpleClass")
    end
    it 'can extract a 5 level nested class' do
      stack_trace = [
          OpenStruct.new(label: '<class:SimpleClass>'),
          OpenStruct.new(label: '<module:ParentModule>'),
          OpenStruct.new(label: '<module:SuperModule>'),
          OpenStruct.new(label: '<module:MegaSuperModule>'),
          OpenStruct.new(label: '<module:TerraSuperModule>'),
          OpenStruct.new(label: '<top (required)>'),
          OpenStruct.new(label: '`matches?')
      ]
      expect(extract_caller_path stack_trace).to eql("TerraSuperModule::MegaSuperModule::SuperModule::ParentModule::SimpleClass")
    end
  end
end