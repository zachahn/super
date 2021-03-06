import { Controller } from "stimulus";

export default class extends Controller {
  call(event) {
    let target = event.target;

    if (target) {
      if (target.checked) {
        this.element.classList.add("opacity-75", "bg-gray-100");
      } else {
        this.element.classList.remove("opacity-75", "bg-gray-100");
      }
    }
  }
}
