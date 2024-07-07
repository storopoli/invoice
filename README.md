# Automated Invoice System

This is a simple script to generate invoices and send them via email.
All you need to do is change the `invoice.toml` file to suit your needs.

## Technical Notes

Dependencies:

- `typst` or `docker`
- `sendmail`
- `sendmail-cf`

Follow the steps [here](https://web.archive.org/web/20240206023834/https://tecadmin.net/configuring-sendmail-through-the-external-smtp-relay/)
to configure `sendmail` to use an external SMTP relay.

Then create a `crontab` entry to run the script at a desired interval.

```bash
0 0 * * * /path/to/automated-invoice-system.sh && ./run.sh
```

The template is based on Typst's [`invoice-maker`](https://typst.app/universe/package/invoice-maker/)
but with some modifications to suit my needs.
