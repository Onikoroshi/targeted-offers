import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Home from "../components/Home";
import Offers from "../components/Offers";

export default (
  <Router>
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/offers" element={<Offers />} />
    </Routes>
  </Router>
);
