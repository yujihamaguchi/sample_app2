# frozen_string_literal: true

module Domain
  module Services
    # タイムスタンプベースでマイクロ秒精度の整数IDを生成
    class IdGenerator
      def self.generate_id
        (Time.now.to_f * 1_000_000).to_i
      end
    end
  end
end
