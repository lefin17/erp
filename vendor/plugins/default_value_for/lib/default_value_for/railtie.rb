# Copyright (c) 2008, 2009, 2010, 2011 Phusion
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Rails 3 initialization

module DefaultValueFor
	def self.initialize_railtie
		ActiveSupport.on_load :active_record do
			DefaultValueFor.initialize_active_record_extensions
		end
	end
	
	def self.initialize_active_record_extensions
		ActiveRecord::Base.extend(DefaultValueFor::ClassMethods)
	end
	
	class Railtie < Rails::Railtie
		initializer 'default_value_for.insert_into_active_record' do
			DefaultValueFor.initialize_railtie
		end
	end
end