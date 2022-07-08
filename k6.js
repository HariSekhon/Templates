//  vim:ts=2:sts=2:sw=2:et
//
//  Author: Hari Sekhon
//  Date: 2022-07-08 15:21:05 +0100 (Fri, 08 Jul 2022)
//
//  [% URL %]
//
//  [% LICENSE %]
//
//  [% MESSAGE %]
//
//  [% LINKEDIN %]
//

import http from 'k6/http';
import { sleep } from 'k6';

// instead of setting on k6 CLI --vus 10 --duration 30s
export const options = {
  vus: 10,
  duration: '30s',

  // or run more complex scenarios of traffic patterns

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
