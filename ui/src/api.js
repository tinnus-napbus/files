import Urbit from "@urbit/http-api";
import axios from "axios";

const api = new Urbit("", "", window.desk || "files");
api.ship = window.ship;

export default api;
