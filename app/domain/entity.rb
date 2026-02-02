# frozen_string_literal: true

module Domain
  # ドメインエンティティの基底クラス
  # エンティティは一意の識別子（ID）によって識別されるドメインオブジェクト
  class Entity
    attr_reader :id

    def initialize(id:, **attributes)
      raise ArgumentError, "id is required" if id.nil?
      @id = id
      @attributes = attributes
      initialize_attributes(attributes)
    end

    # エンティティの同一性はIDで判断される
    def ==(other)
      return false unless other.is_a?(self.class)

      id == other.id
    end

    alias eql? ==

    def hash
      [self.class, id].hash
    end

    # エンティティの属性をハッシュで取得
    def to_h
      { id: id }.merge(@attributes)
    end

    private

    # サブクラスでオーバーライドして属性を初期化
    def initialize_attributes(attributes)
      # サブクラスで実装
    end
  end
end
