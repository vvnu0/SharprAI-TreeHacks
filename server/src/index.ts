import { Hono } from 'hono'
import { logger } from 'hono/logger'
import { prettyJSON } from 'hono/pretty-json'
import { cors } from 'hono/cors'

const app = new Hono()


app.use('*', logger(), prettyJSON())

app.use(
  '*',
  cors({
    origin: '*',
    allowMethods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  })
)

const port = Bun.env.PORT || 8080

export default {
  port,
  fetch: app.fetch,
}
