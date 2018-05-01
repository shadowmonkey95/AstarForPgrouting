class InvoiceBroadcastJob < ApplicationJob
  queue_as :default

  def perform(counter,invoice)
    ActionCable.server.broadcast 'invoice_channel',  counter: render_counter(counter), invoice: render_invoice(invoice)
  end

  private

  def render_counter(counter)
    ApplicationController.renderer.render(partial: 'invoices/counter', locals: { counter: counter })
  end

  def render_invoice(invoice)
    ApplicationController.renderer.render(partial: 'invoices/invoice', locals: { invoice: invoice })
  end
end
