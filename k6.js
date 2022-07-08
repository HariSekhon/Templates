//  vim:ts=4:sts=4:sw=4:et
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

export default function () {
  http.get('https://test.k6.io');
  sleep(1);
}
