// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import Rails from '@rails/ujs';
import * as ActiveStorage from "@rails/activestorage"
import * as bootstrap from "bootstrap"

Rails.start();
ActiveStorage.start();

// Tooltips
// @todo make it work with Turbo
let tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
let tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
  return new bootstrap.Tooltip(tooltipTriggerEl)
})
