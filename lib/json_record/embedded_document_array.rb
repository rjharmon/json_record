module JsonRecord
  # This is an array of EmbeddedDocument objects. All elments of the array must be of the same class
  # and all belong to the same parent. If an array of hashes are passed in, they will all be converted
  # to EmbeddedDocument objects of the class specified.
  class EmbeddedDocumentArray < Array
    def initialize (klass, parent, objects = [])
      @klass = klass
      @parent = parent
      objects = objects.collect do |obj|
        obj = @klass.new(obj) if obj.is_a?(Hash)
        if obj.is_a?(@klass)
          obj.parent = parent
          obj
        else
          raise ArgumentError.new("#{obj.inspect} is not a #{@klass}") unless obj.is_a?(@klass)
        end
      end
      super(objects)
    end
    
    # Append an object to the array. The object must either be an EmbeddedDocument of the
    # correct class, or a Hash.
    def << (obj)
      obj = @klass.new(obj) if obj.is_a?(Hash)
      raise ArgumentError.new("#{obj.inspect} is not a #{@klass}") unless obj.is_a?(@klass)
      obj.parent = @parent
      super(obj)
    end
    
    # Concatenate an array of objects to the array. The objects must either be an EmbeddedDocument of the
    # correct class, or a Hash.
    def concat (objects)
      objects = objects.collect do |obj|
        obj = @klass.new(obj) if obj.is_a?(Hash)
        raise ArgumentError.new("#{obj.inspect} is not a #{@klass}") unless obj.is_a?(@klass)
        obj.parent = @parent
        obj
      end
      super(objects)
    end
    
    # Similar add an EmbeddedDocument to the array and return the object. If the object passed
    # in is a Hash, it will be used to make a new EmbeddedDocument.
    def build (obj)
      obj = @klass.new(obj) if obj.is_a?(Hash)
      raise ArgumentError.new("#{obj.inspect} is not a #{@klass}") unless obj.is_a?(@klass)
      obj.parent = @parent
      self << obj
      obj
    end
  end
end