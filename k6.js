//  vim:ts=2:sts=2:sw=2:et
//  run: k6 run k6.js
//
//  Author: Hari Sekhon
//  Date: [% DATE  # 2022-07-08 15:21:05 +0100 (Fri, 08 Jul 2022) %]
//
//  [% URL %]
//
//  [% LICENSE %]
//
//  [% MESSAGE %]
//
//  [% LINKEDIN %]
//

// https://k6.io/docs/getting-started/running-k6/

import http from 'k6/http';
import { sleep } from 'k6';

// instead of setting on k6 CLI --vus 10 --duration 30s
export const options = {
  vus: 10,
  duration: '30s',

  // or run more complex scenarios of traffic patterns
  //
  // https://k6.io/docs/using-k6/scenarios/
  //
  //scenarios: {
  //  example_scenario: {
  //    // name of the executor to use
  //    executor: 'shared-iterations',
  //
  //    // common scenario configuration
  //    startTime: '10s',
  //    gracefulStop: '5s',
  //    env: { EXAMPLEVAR: 'testing' },
  //    tags: { example_tag: 'testing' },
  //
  //    // executor-specific configuration
  //    vus: 10,
  //    iterations: 200,
  //    maxDuration: '10s',
  //  }
  //}
};

export default function () {
	http.get('https://test.k6.io');
	sleep(1);
}

// more complex requests such as logins
//
//	https://k6.io/docs/using-k6/http-requests/
//
//export default function () {
//  const url = 'http://test.k6.io/login';
//  const payload = JSON.stringify({
//    email: 'aaa',
//    password: 'bbb',
//  });
//
//  const params = {
//    headers: {
//      'Content-Type': 'application/json',
//    },
//  };
//
//  http.post(url, payload, params);
//}
