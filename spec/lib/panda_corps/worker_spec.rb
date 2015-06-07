require 'spec_helper'

module PandaCorps
  describe Worker do
    class TestWorker < Worker
      def manifest
        i_consume :x
        i_consume :y

        i_produce :z
      end
    end

    describe '#work' do
      it 'does some test thin' do
        w = TestWorker.new
        w.product_getters
        puts w.public_methods(false)
      end
    end

    describe '#delegate_to' do

    end

    describe '#commitments' do

    end

    describe '#i_consume' do

    end

    describe '#i_produce' do

    end

    describe '#consumables' do

    end

    describe '#productions' do

    end

    describe '#consume' do

    end

    describe '#produce' do

    end

    describe '#debug info warning error' do

    end

    describe '#start finish accomplished' do

    end

    describe '#handle_exception' do

    end

    describe '#name' do

    end

    describe '#title' do

    end

    describe '#products' do

    end
  end
end